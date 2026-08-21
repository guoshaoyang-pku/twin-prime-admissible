import Sound
import lean_certs.cert_42_186

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H42_gt_186_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 42) (d := 186) (c := cert_42_186) (by decide)
