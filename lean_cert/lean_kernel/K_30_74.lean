import Sound
import lean_certs.cert_30_74

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_74_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 30) (d := 74) (c := cert_30_74) (by decide)
