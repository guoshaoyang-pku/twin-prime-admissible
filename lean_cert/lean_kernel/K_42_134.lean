import Sound
import lean_certs.cert_42_134

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_134_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 42) (d := 134) (c := cert_42_134) (by decide)
