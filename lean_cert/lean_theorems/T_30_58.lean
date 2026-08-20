import Sound
import lean_certs.cert_30_58

open CertVerify

theorem H30_gt_58 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 30) (d := 58) (c := cert_30_58) (by native_decide)
