import Sound
import lean_certs.cert_31_104

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H31_gt_104_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 31) (d := 104) (c := cert_31_104) (by decide)
