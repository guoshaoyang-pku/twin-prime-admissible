import Sound
import lean_certs.cert_37_120

open CertVerify

theorem H37_gt_120 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 37) (d := 120) (c := cert_37_120) (by native_decide)
