import Sound
import lean_certs.cert_36_82

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_82_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 36) (d := 82) (c := cert_36_82) (by decide)
