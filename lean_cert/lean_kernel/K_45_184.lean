import Sound
import lean_certs.cert_45_184

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_184_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 184 := by
  exact certValidRoot_sound (k := 45) (d := 184) (c := cert_45_184) (by decide)
