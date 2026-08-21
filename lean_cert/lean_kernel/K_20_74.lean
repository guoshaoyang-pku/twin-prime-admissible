import Sound
import lean_certs.cert_20_74

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H20_gt_74_kernel : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 20) (d := 74) (c := cert_20_74) (by decide)
