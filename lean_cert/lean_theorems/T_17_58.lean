import Sound
import lean_certs.cert_17_58

open CertVerify

theorem H17_gt_58 : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 17) (d := 58) (c := cert_17_58) (by native_decide)
