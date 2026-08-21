import Sound
import lean_certs.cert_47_212

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H47_gt_212_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 212 := by
  exact certValidRoot_sound (k := 47) (d := 212) (c := cert_47_212) (by decide)
