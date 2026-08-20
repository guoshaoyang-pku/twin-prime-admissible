import Sound
import lean_certs.cert_37_100

open CertVerify

theorem H37_gt_100 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 37) (d := 100) (c := cert_37_100) (by native_decide)
