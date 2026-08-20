import Sound
import lean_certs.cert_31_100

open CertVerify

theorem H31_gt_100 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 31) (d := 100) (c := cert_31_100) (by native_decide)
