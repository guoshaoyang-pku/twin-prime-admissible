import Sound
import lean_certs.cert_49_184

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_184_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 184 := by
  exact certValidRoot_sound (k := 49) (d := 184) (c := cert_49_184) (by decide)
