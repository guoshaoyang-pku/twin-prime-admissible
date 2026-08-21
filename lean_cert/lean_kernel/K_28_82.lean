import Sound
import lean_certs.cert_28_82

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_82_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 28) (d := 82) (c := cert_28_82) (by decide)
