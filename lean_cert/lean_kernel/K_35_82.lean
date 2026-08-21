import Sound
import lean_certs.cert_35_82

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_82_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 35) (d := 82) (c := cert_35_82) (by decide)
