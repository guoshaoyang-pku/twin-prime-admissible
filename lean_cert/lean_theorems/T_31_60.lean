import Sound
import lean_certs.cert_31_60

open CertVerify

theorem H31_gt_60 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 60 := by
  exact certValidRoot_sound (k := 31) (d := 60) (c := cert_31_60) (by native_decide)
