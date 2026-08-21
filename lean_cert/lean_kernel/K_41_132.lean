import Sound
import lean_certs.cert_41_132

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_132_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 41) (d := 132) (c := cert_41_132) (by decide)
