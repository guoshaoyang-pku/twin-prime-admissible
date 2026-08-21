import Sound
import lean_certs.cert_35_146

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_146_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 35) (d := 146) (c := cert_35_146) (by decide)
