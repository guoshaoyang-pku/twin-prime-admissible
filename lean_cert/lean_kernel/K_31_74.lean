import Sound
import lean_certs.cert_31_74

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H31_gt_74_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 31) (d := 74) (c := cert_31_74) (by decide)
