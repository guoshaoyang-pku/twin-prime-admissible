import Sound
import lean_certs.cert_42_168

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_168_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 168 := by
  exact certValidRoot_sound (k := 42) (d := 168) (c := cert_42_168) (by decide)
