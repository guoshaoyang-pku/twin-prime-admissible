import Sound
import lean_certs.cert_48_146

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_146_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 48) (d := 146) (c := cert_48_146) (by decide)
