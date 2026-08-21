import Sound
import lean_certs.cert_41_146

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_146_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 41) (d := 146) (c := cert_41_146) (by decide)
