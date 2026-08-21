import Sound
import lean_certs.cert_27_104

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_104_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 27) (d := 104) (c := cert_27_104) (by decide)
