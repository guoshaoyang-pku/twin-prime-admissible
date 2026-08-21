import Sound
import lean_certs.cert_42_160

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_160_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 42) (d := 160) (c := cert_42_160) (by decide)
