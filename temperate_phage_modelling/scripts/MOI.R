source("CommonFunctions.R")
library(ggplot2)
library(deSolve)

# Parameters. 
# Divide all rates to get rate per 4.5 minutes, which is 1/10th of the lysis time.
multiplier = 1/13.3
V_U = 1.68244586132173*multiplier
V_L = 0.841222930660867*multiplier
H = 2.70324295196332e-08
e = 4.38281752570703e-12
D_b = 0.00248293274733681*multiplier
eta = 0
r = 0.000239052576352519*multiplier
K_a = 2.06338181565078e-08*multiplier
D_p = 1e-07*multiplier
beta = 208.271099881042
d = 0*multiplier
i = 1.14730635311557e-09*multiplier
R_0 = i

K=1.80

out = data.frame()

# Solve the ODEs (at this point, every 1 on the x-axis refers to 4.5 minutes.)
times <- seq(0,to=10000/multiplier,by=1)
initials <- c(U=1, R=R_0/multiplier, P=1, L=0)

out_1 = as.data.frame(ode(func=f, y=initials, parms =c(MOI=1),times = times))
out <- rbind(out, out_1)

# Convert the x-axis back into hours.
out$time = out$time * multiplier

# Make the plots. 
ggplot(out, aes(time))+geom_line(aes(y=U/1000, color='Uninfected')) + geom_line(aes(y=L/1000, color='Lysogens'))+labs(title='Uninfected and Lysogen Concentration vs Time', x='Time (hr)', y='Bacterial Concentration (x 1000 bacteria/mL)') +theme_bw() 
ggplot(out, aes(time))+geom_line(aes(y=P/100000, color='Phage'),color='GREEN') +labs(title='Phage Concentration vs Time', x='Time (hr)', y='Phage Concentration (x 100000 phages/mL)')  +theme_bw()  
ggplot(out, aes(time))+geom_line(aes(y=R*1e+9, color='Resource'),color='PURPLE') +labs(title='Resource Concentration vs Time', x='Time (hr)', y='Glucose Concentration (ng/mL)') + coord_trans(y="log10")+ theme_bw() 
ggplot(out, aes(time))+geom_line(aes(y=phi_moi(K_a,P,K), color='Probability of Lysogeny'),color='MAGENTA') +labs(title='Probability of Lysogeny vs Time', x='Time (hr)', y='Probability of Lysogeny')+ theme_bw() 

# The probability of lysogeny for 1e+9 bacteria/mL.
print(phi_moi(K_a, 1e+9,K))

