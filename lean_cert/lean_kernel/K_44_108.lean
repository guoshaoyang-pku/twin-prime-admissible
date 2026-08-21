import Sound
import lean_certs.cert_44_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_108_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 44) (d := 108) (c := cert_44_108) (by decide)
