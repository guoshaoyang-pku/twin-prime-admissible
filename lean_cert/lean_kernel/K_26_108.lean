import Sound
import lean_certs.cert_26_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_108_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 26) (d := 108) (c := cert_26_108) (by decide)
