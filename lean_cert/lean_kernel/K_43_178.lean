import Sound
import lean_certs.cert_43_178

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_178_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 43) (d := 178) (c := cert_43_178) (by decide)
