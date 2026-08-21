import Sound
import lean_certs.cert_26_74

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_74_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 26) (d := 74) (c := cert_26_74) (by decide)
