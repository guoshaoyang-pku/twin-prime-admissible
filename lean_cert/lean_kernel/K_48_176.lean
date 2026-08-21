import Sound
import lean_certs.cert_48_176

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_176_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 48) (d := 176) (c := cert_48_176) (by decide)
