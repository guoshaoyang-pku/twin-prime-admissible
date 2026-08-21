import Sound
import lean_certs.cert_39_146

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_146_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 39) (d := 146) (c := cert_39_146) (by decide)
