import Sound
import lean_certs.cert_48_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_108_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 48) (d := 108) (c := cert_48_108) (by decide)
