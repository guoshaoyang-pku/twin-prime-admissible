import Sound
import lean_certs.cert_37_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_108_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 37) (d := 108) (c := cert_37_108) (by decide)
