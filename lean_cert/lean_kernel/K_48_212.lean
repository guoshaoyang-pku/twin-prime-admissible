import Sound
import lean_certs.cert_48_212

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H48_gt_212_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 212 := by
  exact certValidRoot_sound (k := 48) (d := 212) (c := cert_48_212) (by decide)
