import Sound
import lean_certs.cert_37_74

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_74_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 37) (d := 74) (c := cert_37_74) (by decide)
