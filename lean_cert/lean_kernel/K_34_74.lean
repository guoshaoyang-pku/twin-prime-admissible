import Sound
import lean_certs.cert_34_74

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_74_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 34) (d := 74) (c := cert_34_74) (by decide)
