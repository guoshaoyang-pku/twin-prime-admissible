import Sound
import lean_certs.cert_42_150

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_150_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 42) (d := 150) (c := cert_42_150) (by decide)
