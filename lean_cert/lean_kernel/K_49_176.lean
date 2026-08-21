import Sound
import lean_certs.cert_49_176

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_176_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 49) (d := 176) (c := cert_49_176) (by decide)
