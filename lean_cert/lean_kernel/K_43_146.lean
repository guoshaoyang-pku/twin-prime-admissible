import Sound
import lean_certs.cert_43_146

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_146_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 43) (d := 146) (c := cert_43_146) (by decide)
