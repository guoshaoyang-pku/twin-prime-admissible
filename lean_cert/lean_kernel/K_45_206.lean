import Sound
import lean_certs.cert_45_206

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H45_gt_206_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 206 := by
  exact certValidRoot_sound (k := 45) (d := 206) (c := cert_45_206) (by decide)
