import Sound
import lean_certs.cert_38_146

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_146_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 38) (d := 146) (c := cert_38_146) (by decide)
