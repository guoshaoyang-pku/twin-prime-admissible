import Sound
import lean_certs.cert_42_104

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_104_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 42) (d := 104) (c := cert_42_104) (by decide)
