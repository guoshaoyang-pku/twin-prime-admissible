import Sound
import lean_certs.cert_25_74

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_74_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 25) (d := 74) (c := cert_25_74) (by decide)
