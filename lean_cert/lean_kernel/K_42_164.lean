import Sound
import lean_certs.cert_42_164

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_164_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 42) (d := 164) (c := cert_42_164) (by decide)
