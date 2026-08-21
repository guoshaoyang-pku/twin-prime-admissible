import Sound
import lean_certs.cert_21_74

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H21_gt_74_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 21) (d := 74) (c := cert_21_74) (by decide)
