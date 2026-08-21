import Sound
import lean_certs.cert_22_74

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H22_gt_74_kernel : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 22) (d := 74) (c := cert_22_74) (by decide)
