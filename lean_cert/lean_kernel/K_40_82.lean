import Sound
import lean_certs.cert_40_82

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_82_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 40) (d := 82) (c := cert_40_82) (by decide)
