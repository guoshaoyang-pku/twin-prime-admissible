import Sound
import lean_certs.cert_41_82

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_82_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 41) (d := 82) (c := cert_41_82) (by decide)
