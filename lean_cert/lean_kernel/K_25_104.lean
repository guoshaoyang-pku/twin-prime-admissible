import Sound
import lean_certs.cert_25_104

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_104_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 25) (d := 104) (c := cert_25_104) (by decide)
