import Sound
import lean_certs.cert_43_134

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_134_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 43) (d := 134) (c := cert_43_134) (by decide)
