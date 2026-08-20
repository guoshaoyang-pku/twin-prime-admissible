import Sound
import lean_certs.cert_49_230

open CertVerify

theorem H49_gt_230 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 230 := by
  exact certValidRoot_sound (k := 49) (d := 230) (c := cert_49_230) (by native_decide)
