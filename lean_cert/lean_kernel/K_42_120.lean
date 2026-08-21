import Sound
import lean_certs.cert_42_120

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_120_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 42) (d := 120) (c := cert_42_120) (by decide)
