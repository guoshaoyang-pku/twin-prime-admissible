import Sound
import lean_certs.cert_45_146

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_146_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 45) (d := 146) (c := cert_45_146) (by decide)
